class ChangePlanets < ActiveRecord::Migration[5.0]
  def change
    %w(integer bigint).each do |psql_type|
      execute <<-SQL
        create or replace function "cast_to_#{psql_type}"(text, #{psql_type}) returns #{psql_type} as $$
        begin
          return cast($1 as #{psql_type});
        exception
          when invalid_text_representation then
            return $2;
        end;
        $$ language plpgsql immutable;
      SQL
    end

    %w(rotation_period orbital_period diameter surface_water population).each do |property|
      props.each_with_index do |property, i|
        type_func = i < 4 ? ["integer", "cast_to_integer"] : ["bigint", "cast_to_bigint"]

      execute <<-SQL
        alter table planets alter #{property} drop default;

        alter table planets alter column #{property} type #{type_func[0]} using #{type_func[1]}(#{property}, 0);

        alter table planets alter #{property} set default 0;
      SQL
      end
    end
  end
end

class ChangeStarships < ActiveRecord::Migration[5.0]
  def change
    %w(integer bigint float).each do |psql_type|
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

    props = %w(max_atmosphering_speed crew passengers cost_in_credits cargo_capacity length hyperdrive_rating)

    props.each_with_index do |property, i|
      type_func = 
        if i < 3
          ["integer", "cast_to_integer"]
        elsif i < 5
          ["bigint", "cast_to_bigint"]
        else
          ["float", "cast_to_float"]
        end

      execute <<-SQL
        alter table starships alter #{property} drop default;

        alter table starships alter column #{property} type #{type_func[0]} using #{type_func[1]}(#{property}, 0);

        alter table starships alter #{property} set default 0;
      SQL
    end
  end
end

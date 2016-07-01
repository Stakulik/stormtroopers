class ChangePeople < ActiveRecord::Migration[5.0]
  def change
    execute <<-SQL
      create or replace function cast_to_int(text, integer) returns integer as $$
      begin
        return cast($1 as integer);
      exception
        when invalid_text_representation then
          return $2;
      end;
      $$ language plpgsql immutable;
    SQL

    %w(height mass).each do |property|
      execute <<-SQL
        alter table people alter #{property} drop default;

        alter table people alter column #{property} type integer using cast_to_int(#{property}, 0);

        alter table people alter #{property} set default 0;
      SQL
    end
  end
end

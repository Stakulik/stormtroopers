class ChangePeopleBirthYear < ActiveRecord::Migration[5.0]
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

    execute <<-SQL
      alter table people alter birth_year drop default;

      alter table people alter column birth_year type integer using cast_to_int(birth_year, 0);

      alter table people alter birth_year set default 0;
    SQL
  end
end

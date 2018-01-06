with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

procedure Advent19 is
    File : File_Type;
    m : array(1..200) of Unbounded_String;
    c: Natural := 1;
    s: unbounded_string := To_Unbounded_String("");
    stepCount : integer := 0;

    procedure turn (r, c: in integer; dr, dc: in out integer) is
    begin
        if r < 200 and then not (dr = -1 and dc = 0) and then element(m(r + 1), c) /= ' ' then
            dr := 1;
            dc:= 0;
        elsif r > 1 and then not (dr = 1 and dc = 0) and then element(m(r - 1), c) /= ' ' then
            dr:= -1;
            dc := 0;
        elsif c < 200 and then not (dr = 0 and dc = -1) and then element(m(r), c + 1) /= ' ' then
            dr := 0;
            dc := 1;
        elsif c > 1 and then not (dr = 0 and dc = 1) and then element(m(r), c - 1) /= ' ' then
            dr := 0;
            dc := -1;
        end if;
    end turn;

    procedure solve (r, c, dr, dc: in integer; s: in out unbounded_string) is
    begin
        stepCount := stepCount + 1;
        if element(m(r),c) = '|' or element(m(r),c) = '-' then
            solve (r + dr, c + dc, dr, dc, s);
        elsif element(m(r),c) = '+' then
            declare
                drn: integer := dr;
                dcn: integer := dc;
            begin
                turn(r, c, drn, dcn);
                solve (r + drn, c + dcn, drn, dcn, s);
            end;
        elsif element(m(r),c) /= ' ' then
            append(s, element(m(r),c));
            solve (r + dr, c + dc, dr, dc, s);
        end if;
    end solve;
begin

    Open (File => File,
          Mode => In_File,
          Name => "input19.txt");
    loop
        exit when End_Of_File (File);
        declare
            s: string := get_line (File);
        begin
            m(c) :=  To_Unbounded_String (s);
            c := c + 1;
        end;
    end loop;
    Close (File);

    c := 1;
    while c <= length(m(1)) and element(m(1),c) /= '|' loop
        c := c + 1;
    end loop;

    solve(1, c, 1, 0, s);
    put_line(s);
    put_line(Integer'Image(stepCount - 1));
end Advent19;


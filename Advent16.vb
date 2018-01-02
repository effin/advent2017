Imports System.IO

Class Advent16
    Shared Function Spin(ByVal s As String, ByVal n As Int16)
        Return s.Substring(s.Length - n) & s.Substring(0, s.Length - n)
    End Function

    Shared Function Exchange(ByVal s As String, ByVal p1 As Int16, ByVal p2 As Int16)
        Dim c1 As Char = s.Chars(Math.Min(p1, p2))
        Dim c2 As Char = s.Chars(Math.Max(p1, p2))
        Return s.Substring(0, Math.Min(p1, p2)) & c2 & s.Substring(Math.Min(p1, p2) + 1, Math.Max(p1, p2) - Math.Min(p1, p2) - 1) & c1 & s.Substring(Math.Max(p1, p2) + 1)
    End Function

    Shared Function Partner(ByVal s As String, ByVal c1 As Char, ByVal c2 As Char)
        Dim p1 As Int16 = s.IndexOf(c1)
        Dim p2 As Int16 = s.IndexOf(c2)
        Return Exchange(s, p1, p2)
    End Function

    Shared Function Dance(ByVal programs, ByVal moves)
        For Each command In moves
            If command.StartsWith("s") Then
                Dim n As Int16 = Int16.Parse(command.Substring(1))
                programs = Spin(programs, n)
            ElseIf command.StartsWith("x") Then
                Dim n1 As Int16 = Int16.Parse(command.Substring(1, command.IndexOf("/"c) - 1))
                Dim n2 As Int16 = Int16.Parse(command.Substring(command.IndexOf("/"c) + 1))
                programs = Exchange(programs, n1, n2)
            ElseIf command.StartsWith("p") Then
                Dim c1 As Char = command.Chars(1)
                Dim c2 As Char = command.Chars(3)
                programs = Partner(programs, c1, c2)
            End If
        Next
        Return programs
    End Function

    Public Shared Sub Main()
        Const START As String = "abcdefghijklmnop"
        Dim programs As String = START
        Dim moves As List(Of String) = New List(Of String)

        Try
            Using sr As New StreamReader("input16.txt")
                Dim line As String
                line = sr.ReadToEnd()
                Dim delimiter As Char = ","c
                Dim commands() As String = line.Split(delimiter)
                For Each command In commands
                    moves.Add(command)
                Next
            End Using

        Catch e As Exception
            Console.WriteLine("The file could not be read:")
            Console.WriteLine(e.Message)
        End Try

        programs = Dance(programs, moves)
        Console.WriteLine(programs)

        Dim loopSize As Integer = 1
        While programs <> START
            programs = Dance(programs, moves)
            loopSize += 1
        End While
        For index As Integer = 1 To 1000000000 Mod loopSize
            programs = Dance(programs, moves)
        Next

        Console.WriteLine(programs)
        Console.Write("Press any key to continue...")
        Console.ReadKey(True)

    End Sub
End Class
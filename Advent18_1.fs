open System
open System.IO

let readLines (filePath:string) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

let parseCommand (line:string) = line.Split [|' '|]

let parseVal (s:string) (rs:Map<string,int64>) = if System.Int64.TryParse s |> fst then s |> int64 else if rs.ContainsKey s then rs.[s] else 0L

let nextPos (cmd:string[]) (pos, sound, rs:Map<string,int64>, rcv) =
    match cmd.[0] with
    | "snd" -> (pos + 1L, (parseVal cmd.[1] rs), rs, rcv)
    | "set" -> (pos + 1L, sound, rs.Add(cmd.[1], (parseVal cmd.[2] rs)), rcv)
    | "add" -> (pos + 1L, sound, rs.Add(cmd.[1], (parseVal cmd.[1] rs) + (parseVal cmd.[2] rs)), rcv)
    | "mul" -> (pos + 1L, sound, rs.Add(cmd.[1], (parseVal cmd.[1] rs) * (parseVal cmd.[2] rs)), rcv)
    | "mod" -> (pos + 1L, sound, rs.Add(cmd.[1], (parseVal cmd.[1] rs) % (parseVal cmd.[2] rs)), rcv)
    | "rcv" -> (pos + 1L, sound, rs, if rs.[cmd.[1]] = 0L then rcv else sound)
    | "jgz" -> (pos + (if rs.[cmd.[1]] <= 0L then 1L else (cmd.[2] |> int64)), sound, rs, rcv)
    | _ -> failwith "operation not supported"

let rec duet (lines:string[]) (pos, sound, rs, rcv) = 
    if rcv <> 0L || pos < 0L || pos >= (lines.Length |> int64) then rcv
    else duet lines (nextPos (parseCommand lines.[pos |> int]) (pos, sound, rs, rcv))

[<EntryPoint>]
let main argv =
    let lines = readLines "input18.txt" 
    Console.WriteLine (duet (Seq.toArray lines) (0L, 0L, Map.empty, 0L))
    let _ = Console.ReadKey true
    0 
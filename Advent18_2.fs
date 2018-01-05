open System
open System.IO

let readLines (filePath:string) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

let parseCommand (line:string) = line.Split [|' '|]

let parseVal (s:string) (rs:Map<string,int64>) = if System.Int64.TryParse s |> fst then s |> int64 else if rs.ContainsKey s then rs.[s] else 0L

type State = Starting | Waiting | Sending | Sent | Terminated 

let nextPos (cmd:string[]) (pos, rs:Map<string,int64>, q:List<int64>, state, sendCount, sendValue) =
    match cmd.[0] with
    | "set" -> (pos + 1L, rs.Add(cmd.[1], (parseVal cmd.[2] rs)), q, state, sendCount, sendValue)
    | "add" -> (pos + 1L, rs.Add(cmd.[1], (parseVal cmd.[1] rs) + (parseVal cmd.[2] rs)), q, state, sendCount, sendValue)
    | "mul" -> (pos + 1L, rs.Add(cmd.[1], (parseVal cmd.[1] rs) * (parseVal cmd.[2] rs)), q, state, sendCount, sendValue)
    | "mod" -> (pos + 1L, rs.Add(cmd.[1], (parseVal cmd.[1] rs) % (parseVal cmd.[2] rs)), q, state, sendCount, sendValue)
    | "jgz" -> (pos + (if parseVal cmd.[1] rs <= 0L then 1L else (parseVal cmd.[2] rs)), rs, q, state, sendCount, sendValue)
    | "snd" -> 
        (if state = Sending then failwith "cannot send again"
        else (pos + 1L, rs, q, Sending, sendCount + 1, (parseVal cmd.[1] rs)))
    | "rcv" -> 
        (if q.IsEmpty then (pos, rs, q, Waiting, sendCount, sendValue) 
        else (pos + 1L, rs.Add(cmd.[1], q.Head), q.Tail, state, sendCount, sendValue))
    | _ -> failwith "operation not supported"

let rec duet (lines:string[]) (pos, rs, q:List<int64>, state, sendCount, sendValue) = 
    if state = Sending || (state = Waiting && q.IsEmpty) then (pos, sendValue, rs, state, sendCount, q)
    else if pos < 0L || pos >= (lines.Length |> int64) then (pos, sendValue, rs, Terminated, sendCount, q)
    else duet lines (nextPos (parseCommand lines.[pos |> int]) (pos, rs, q, state, sendCount, sendValue))

let rec parallell (lines:string[]) 
            (pos1, snd1, rs1, state1, sendCount1, q1:List<int64>) 
            (pos2, snd2, rs2, state2, sendCount2, q2:List<int64>) =
    if ((state1 = Waiting && state2 <> Sending && q1.IsEmpty) || state1 = Terminated) 
        && ((state2 = Waiting && state1 <> Sending && q2.IsEmpty) || state2 = Terminated) 
    then sendCount2
    else parallell lines 
                    (duet lines (pos1, rs1, (if state2 = Sending then List.append q1 [snd2] else q1), (if state1 = Sending then Sent else state1), sendCount1, 0L)) 
                    (duet lines (pos2, rs2, (if state1 = Sending then List.append q2 [snd1] else q2), (if state2 = Sending then Sent else state2), sendCount2, 0L))

[<EntryPoint>]
let main argv =
    let lines = readLines "input18.txt" 
    Console.WriteLine (parallell (Seq.toArray lines) (0L, 0L, Map.empty, Starting, 0, List.Empty) (0L, 0L, Map.empty.Add("p", 1L), Starting, 0, List.Empty))
    let _ = Console.ReadKey true
    0 

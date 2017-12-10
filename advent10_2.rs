fn tohex(slice: &[i32]) -> String {
    let mut buf = String::with_capacity(32);
    for i in 0..16 {
        let mut xor = slice[16 * i];
        for j in 1..16 {
            xor ^= slice[16 * i + j];
        }
        buf.push_str(&format!("{:02x}", xor));
    }
    buf
}

fn rev(slice: &mut [i32], start: usize, end: usize) {
    let mut i = 0;
    let total = 1 + slice.len() - start + end as usize;
    while i < total / 2 {
        let mut i1 = start + i;
        let mut i2: i32 = end as i32 - i as i32;
        if i1 >= slice.len() {
            i1 = i1 % slice.len();
        }
        if i2 < 0 {
            i2 = slice.len() as i32 + i2;
        }
        slice.swap(i1, i2 as usize);
        i += 1;
    }
}

fn main() {
    let inputstring = "130,126,1,11,140,2,255,207,18,254,246,164,29,104,0,224";
    let mut input: [usize; 59] = [0; 59];
    for n in 0..54 {
        input[n] = inputstring.chars().nth(n).unwrap() as usize;
    }
    input[54] = 17;
    input[55] = 31;
    input[56] = 73;
    input[57] = 47;
    input[58] = 23;

    let mut v: [i32; 256] = [0; 256];
    for n in 0..256 {
        v[n] = n as i32;
    }

    let mut pos = 0;
    let mut skip = 0;
    for _r in 0..64 {
        for n in input.iter() {
            let end = pos + n;
            if end <= 256 {
                let slice = &mut v[pos..end];
                slice.reverse();
            } else {
                rev(&mut v, pos, (end - 1) % 256);
            }

            pos += n + skip;
            pos = pos % 256;
            skip += 1;
        }
    }
    println!("hash {}", tohex(&v));
}

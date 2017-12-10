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
    let input: [usize; 16] = [130, 126, 1, 11, 140, 2, 255, 207, 18, 254, 246, 164, 29, 104, 0, 224];

    let mut v: [i32; 256] = [0; 256];
    for n in 0..256 {
        v[n] = n as i32;
    }

    let mut pos = 0;
    let mut skip = 0;

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
    println!("hash {}", v[0] * v[1]);
}

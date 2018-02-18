def calcStrongest(bridge, last, strength, unused)
    max = strength;
    index = 0
    for c in unused
        b = bridge.clone
        b[bridge.length] = c
        u = unused.clone
        u.delete_at index
        if last < 0 && c[0] == 0
            m = calcStrongest(b, c[1], strength + c[1], u)
            if m > max
                max = m
            end
        end
        if last < 0 && c[1] == 0 && c[0] != 0
            m = calcStrongest(b, c[0], strength + c[0], u)
            if m > max
                max = m
            end
        end
        if c[0] == last
            m = calcStrongest(b, c[1], strength + c[0] + c[1], u)
            if m > max
                max = m
            end
        end
        if c[1] != c[0] && c[1] == last
            m = calcStrongest(b, c[0], strength + c[0] + c[1], u)
            if m > max
                max = m
            end
        end
        index += 1
    end
    return max
end

File.open("input24.txt", "r") do |f|
  components = []
  f.each_line do |line|
    components << [Integer(line.split("/").first), Integer(line.split("/").last)]
  end
  puts calcStrongest([], -1, 0, components)
end

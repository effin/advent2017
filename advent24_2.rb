def calcStrongest(bridge, last, strength, unused)
    max = strength;
    len = bridge.length
    index = 0
    for c in unused
        b = bridge.clone
        b[bridge.length] = c
        u = unused.clone
        u.delete_at index
        if last < 0 && c[0] == 0
            ml = calcStrongest(b, c[1], strength + c[1], u)
            if ml[1] >= len && ml[0] > max
                max = ml[0]
                len = ml[1]
            end
        end
        if last < 0 && c[1] == 0 && c[0] != 0
            ml = calcStrongest(b, c[0], strength + c[0], u)
            if ml[1] >= len && ml[0] > max
                max = ml[0]
                len = ml[1]
            end
        end
        if c[0] == last
            ml = calcStrongest(b, c[1], strength + c[0] + c[1], u)
            if ml[1] >= len && ml[0] > max
                max = ml[0]
                len = ml[1]
            end
        end
        if c[1] != c[0] && c[1] == last
            ml = calcStrongest(b, c[0], strength + c[0] + c[1], u)
            if ml[1] >= len && ml[0] > max
                max = ml[0]
                len = ml[1]
            end
        end
        index += 1
    end
    return [max, len]
end

File.open("input24.txt", "r") do |f|
  components = []
  f.each_line do |line|
    components << [Integer(line.split("/").first), Integer(line.split("/").last)]
  end
  puts calcStrongest([], -1, 0, components)[0]
end

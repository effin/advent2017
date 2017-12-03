input = 325489

# part 1

prev = next = 2
n = 0
while next < input:
    prev = next
    next = next + {
        0: 2 * (n / 4 + 1),
        1: 2 * (n / 4 + 1),
        2: 2 * (n / 4 + 1),
        3: 2 * (n / 4 + 1) + 1
    }.get(n % 4)
    n = n + 1

print min([input - prev, next - input]) + n / 4 + 1

# part 2

s = [[0 for x in range(11)] for y in range(11)]
s[5][5] = 1
[x, y] = [5, 5]
[dx, dy] = [0, 1]

while s[x][y] < input:
    if dy < 0 and s[x - 1][y] == 0:
        [dx, dy] = [-1, 0]
    elif dx < 0 and s[x][y + 1] == 0:
        [dx, dy] = [0, 1]
    elif dy > 0 and s[x + 1][y] == 0:
        [dx, dy] = [1, 0]
    elif dx > 0 and s[x][y - 1] == 0:
        [dx, dy] = [0, -1]
    [x, y] = [x + dx, y + dy]
    s[x][y] = s[x - 1][y] + s[x - 1][y - 1] + s[x][y - 1] + s[x + 1][y - 1] \
              + s[x + 1][y] + s[x + 1][y + 1] + s[x][y + 1] + s[x - 1][y + 1]

print s[x][y]

rules = open('rules.txt')
i = 500
for rule in rules.readlines():
    if rule.startswith('#'):
        continue
    else:
        parts = rule.split(' ')
        range = parts[3]
        print '  "%d Drop known troublesome range (%s)":' % (i, range)
        print '    source:', '"%s"' % range
        print '    action: drop'
        i += 1

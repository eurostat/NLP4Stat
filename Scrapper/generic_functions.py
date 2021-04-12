# Text normalization (\n \t \r)
def normalize(txt):
    txt = txt.replace('\r', '')
    txt = txt.replace('\n', '')
    txt = txt.replace('\t', '')
    txt = txt.replace('\xa0', ' ')
    txt = txt.replace('  ', ' ')
    return txt
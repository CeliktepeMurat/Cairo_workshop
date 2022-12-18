from starkware.cairo.common.serialize import serialize_word

func main():
    [ap] = 100; ap++
    # << Your code here >>
    [ap - 6] = [fp] * [fp]  #x^2
    [ap - 5] = [ap - 6] + [fp]  # x^3
    [ap - 4] = [ap - 6] * 23 # 23x^2
    [ap - 3] = [ap] * 45  # 45x 
    [ap - 2] = [ap - 5] + [ap - 4]
    [ap + 5] = [fp + 4] + [fp + 3]; ap++
    [ap - 1] = [ap + 5] + 67
    ret
end
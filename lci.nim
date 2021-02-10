import strutils

while true:
    write(stdout, "λ> ")
    let inp = strip(readLine(stdin))

    if inp == "quit":
        break

    echo "Input was ", inp
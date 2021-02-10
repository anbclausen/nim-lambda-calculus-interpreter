import strutils

while true:
    write(stdout, "λ] ")
    let inp = readLine(stdin).strip()

    if inp == "quit":
        break

    echo "Input was ", inp
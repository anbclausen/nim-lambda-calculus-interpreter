while true:
    write(stdout, "λ> ")
    let inp = readLine(stdin)

    if inp == "quit":
        break
    
    echo "Input was ", inp
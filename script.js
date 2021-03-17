let input, output;
window.onload = () => {
    input = document.getElementById('input');
    output = document.getElementById('output-content');
    input.focus();
    input.select();
}

function enter(e) {
    if(e.code == "Enter") {
        const added = "λ] ".toString() + input.value.toString().trim() + "<br>"
        const inp = input.value.toString().trim()
        input.value = "";
        const res = run(inp);
        output.innerHTML += added
        if(res != "") {
            output.innerHTML += "&nbsp;&nbsp;&nbsp;" + res + "<br>"
        }
    }
}
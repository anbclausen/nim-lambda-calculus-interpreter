let input, output;
window.onload = () => {
    input = document.getElementById('input');
    output = document.getElementById('output-content');
    input.focus();
    input.select();
}

function enter(e) {
    if(e.code == "Enter") {
        const res = run(input.value);
        output.innerHTML += input.value + "<br>"
        if(res != "") {
            output.innerHTML += "&nbsp;&nbsp;" + res + "<br>"
        }
        input.value = "";
    }
}
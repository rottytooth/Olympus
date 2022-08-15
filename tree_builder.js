// The tree we get from the PEG parser describes the program but is more of a "meta-tree", where not everything is yet in order. This parses that output and produces a more traditional AST of the final program, which can then be turned easily into code.
const fs = require('fs');
const { registerTask } = require('grunt');


INPUT_FILE = './sample_code/99bottles.json';

// BUILDERS
// make sure functions and loops all have the same structure
const make_func = (name, params) => {
    return {name: name, params: params, body: []};
}
const make_for_loop = (name, start, end, step) => {
    return {name: name, start: start, end: end, step: step};
}
const make_while_loop = (name, condition) => {
    return {name: name, condition: condition};
}

const func_list = {}; // holds all functions
func_list["main"] = (make_func("main", null, "")); // add main

const build_function = (inv) => {

    let func = make_func(
        inv.requests[0].id, // name
        inv.requests[0].params.map(n => n.name) // params
    );

    // add commands to function
    for(let i = 1; i < inv.requests.length; i++) { // skip first request
        func.body.push(build_command(inv.requests[i])[0]); // get first request, the cmd itself
    }
    func_list[inv.requests[0].id] = func;
}

const build_command = (req, id = null) => {

    if (req.id === "<prev id>" && id) {
        req.id = id;
    }

    cmd = req;

    // are we adding to a function or returning result?
    if (req.loc) {
        cmd = null; // we will not return if we're adding it to a particular place
    }

    return [cmd, id];
}

fs.readFile(INPUT_FILE, 'utf8', (err, data) => {

    source = "";
    function_list = [];

    if (err) {
        console.log(`Error reading file from disk: ${err}`);
    } else {

        // parse JSON string to JSON object
        const c = JSON.parse(data);

        c.invocations.forEach(inv => {

            // top-level items; all following requests in this invocation will fall under this first request
            if (['function','check'].includes(inv.requests[0].type)) {
                func_list.push(build_function(inv));
            } else { // the individual requests under an invocation
                let id = null;
                inv.requests.forEach(r => { 
                    const [cmd, id] = build_command(r, id);
                });
            }
        });

        // // add all the functions to the source code
        // let final_source = ""; // we're going to put the functions in first
        // function_list.forEach(func => final_source += func.func + "}\n");

        // final_source += source; // now add all the "main flow"

        // console.log(source);
        // fs.writeFile("sample_code/99bottles.js", final_source, function (err) {
        //     if (err) return console.log(err);
        //   });
    }

});

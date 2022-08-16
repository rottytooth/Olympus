const exp = require('constants');
const fs = require('fs');
const { registerTask } = require('grunt');
const { PassThrough } = require('stream');

var function_list;

INPUT_FILE = './sample_code/99bottles.json';

PRINT_CMD = 'console.write'
ESCAPED_NEWLINE = '\\n'

const build_command = (r) => {
    let statement = "";
    
    // only return a string if the command is added to the parent (usually the main flow)
    switch(r.type) {
        case "assign_condition":
            statement += `if (${build_expression(r.exp)}) {\n`;
            statement += `\t${r.id}(${r.param});\n`;
            statement += "}\n";
            break;
        case "var":
            statement += `let ${r.id};\n`;
            prev_id = r.id;
            break;
        case "assign":
            varname = r.id;
            if (varname === '<prev id>')
                varname = prev_id;
                statement += `${varname} = ${build_expression(r.exp)};\n`;
            break;
        case "call":
            paramlist = "";
            if (r.params)
                paramlist = r.params.map(e => e.name).join(",");
            statement += `${r.id}(${paramlist});\n`;
            break;
        case "for":
            let start = build_expression(r.start);
            let end = build_expression(r.end);
            let test = `${r.id}_counter ${r.start > end ? ">" : "<"} ${end}`;
            let change = `${r.id}_counter++`;
            if (start > end) { change = `${r.id}_counter--`};
            statement += `for (let ${r.id}_counter = ${start}; ${test}; ${change}) {\n`;
            statement += `\t${r.id}();\n`;
            statement += "}\n";
            break;
        case "print":
            let to_print = build_expression(r.exp, true)
            if (to_print.constructor === Array) to_print = to_print.join("+ ");
            statement += `${PRINT_CMD}(${to_print});\n`;
            break;
    }

    if (!r.loc) // no location provided, return the statement
        return statement;

    // otherwise, a specific location was provided, add to that location
    func_matches = function_list.filter(e => e.name == r.loc);
    if (func_matches.length != 1)
        throw(`Could not find function ${r.loc}`);
    console.log(func_matches[0].func);
    func_matches[0].func += "\t" + statement;
    console.log(func_matches[0].func);
}

const build_function = (inv) => {
    retstr = "";
    let funcname = inv.requests[0].id;

    // // do we need to do anything different as a "check"?
    // if (inv.requests[0].type == "check") {
    //     // add actual check
    // }

    if (inv.requests[0].params)
        paramstr = inv.requests[0].params.map(n => n.name).join(",");

    retstr += `const ${funcname} = (${paramstr}) => {\n`;

    for(let i = 1; i < inv.requests.length; i++) {
        retstr += (build_command(inv.requests[i], true))
    }

    return [funcname, retstr];
}

const build_expression = (exp, asString=false) => {
    if (exp.constructor !== Array) {
        switch(exp.type) {
            case "VariableName":
                if (asString) return exp.name + ".asString() "
                return exp.name;
            case "IntLiteral":
                if (asString) return exp.value + ".toString() "
                return exp.value.toString();
            case "StringLiteral":
                return '`' + exp.value.replace(/\n/g, ESCAPED_NEWLINE) + '`';
            case "Comparison":
                return build_expression(exp.left) + " " + exp.operator + " " + build_expression(exp.right);
        }
    }
    let retset = [];
    exp.forEach(e => {
        retset.push(build_expression(e, asString));
    });
    return retset;
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
                const [name, func] = build_function(inv);
                function_list.push({'name':name,'func': func});
            } else { // the individual requests under an invocation
                inv.requests.forEach(r => { cmd = build_command(r); if (typeof cmd !== "undefined") source += cmd; });
            }
        });

        // add all the functions to the source code
        let final_source = ""; // we're going to put the functions in first
        function_list.forEach(func => final_source += func.func + "}\n");

        final_source += source; // now add all the "main flow"

        console.log(final_source);
        fs.writeFile("sample_code/99bottles.js", final_source, function (err) {
            if (err) return console.log(err);
          });
    }

});

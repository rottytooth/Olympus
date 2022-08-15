const fs = require('fs');
const { registerTask } = require('grunt');


var function_list;

const build_function = (inv) => {
    // first req should be the function declaration
    // if (inv.requests[0].type !== 'function') {
    //     throw("invalid build_function() call");
    // }
    retstr = "";
    let funcname = inv.requests[0].id;

    if (inv.requests[0].params)
        paramstr = inv.requests[0].params.map(n => n.name).join(",");

    retstr += `const ${funcname} = (${paramstr}) => {\n`;

    for(let i = 1; i < inv.requests.length; i++) {
        retstr += (build_command(inv.requests[i], true))
    }

//    retstr += "}\n";

    return [funcname, retstr];
}

const build_expression = (exp) => {
    if (exp.constructor !== Array) {
        switch(exp.type) {
            case "VariableName":
                return exp.name;
            case "StringLiteral":
                return '"' + escape(exp.value) + '"';
            case "Comparison":
                return "(" + build_expression(exp.left) + " " + exp.operator + " " + build_expression(exp.right) + ")";
        }
    }
    let retset = [];
    exp.forEach(e => {
        retset.push(build_expression(e));
    });
    return retset;
}

const build_print = (req, tab) => {
    let loc = req.loc; // in some cases, this gets written to a particular function
    let retstr = "";

    [].concat(req.exp).forEach(e => {
        if (tab) retstr += "\t";
        retstr += `console.log(${build_expression(e)});\n`
    });
    return retstr;
}

const build_function_call = (req, tab) => {
    let loc = req.loc; // in some cases, this gets written to a particular function
    let retstr = "";
    if (tab) retstr += "\t";
    
    retstr += `${req.id}(`;
    retstr += req.params.map(e => e.name).join(",");

    retstr += ");\n"
    return retstr;
}

const build_command = (req, tab) => {
    let retstr = "";
    switch(req.type) {
        case "print":
            return build_print(req, tab);
        case "call":
            return build_function_call(req, tab);
    }
    return retstr;
}

fs.readFile('./sample_code/99bottles.json', 'utf8', (err, data) => {

    source = "";
    function_list = [];

    if (err) {
        console.log(`Error reading file from disk: ${err}`);
    } else {

        // parse JSON string to JSON object
        const c = JSON.parse(data);

        c.invocations.forEach(inv => {
            // a set of connected requests

            var prev_id = ""; // assigned when we know the name of the id created or assigned by name and afterword called it

            // first requests
            if (['function','check'].includes(inv.requests[0].type)) {
                const [name, func] = build_function(inv);
                function_list.push({'name':name,'func': func});
            } else {
                inv.requests.forEach(r => {

                    statement = "";

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
                            break;
                    }

                    if (!r.loc) // no location provided, add to the main thread
                        source += statement;
                    else {
                        func_matches = function_list.filter(e => e.name == r.loc);
                        if (func_matches.length != 1)
                            throw(`Could not find function ${r.loc}`);
                        console.log(func_matches[0].func);
                        func_matches[0].func += "\t" + statement;
                        console.log(func_matches[0].func);
                    }
                });
//                console.log(source);
            }

            // inv.requests.forEach(req => {
            //     console.log(`${req.type}`)
            // });
        });

        // add all the functions to the source code
        let final_source = ""; // we're going to put the functions in first
        function_list.forEach(func => final_source += func.func + "}\n");

        final_source += source; // now add all the "main flow"

        console.log(source);
        fs.writeFile("sample_code/99bottles.js", final_source, function (err) {
            if (err) return console.log(err);
          });
    }

});

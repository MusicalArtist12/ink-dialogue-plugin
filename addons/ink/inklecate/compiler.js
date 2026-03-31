// Julia Abdel-Monem
// Simple Inkjs compiler wrapper that outputs the json to the console
// Usage: node compiler.js <path-to-source>
const fs = require("node:fs")
const inkjs = require("inkjs/full") //the `full` submodule contains the Compiler

const filePath = process.argv[2]

fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
        console.error(err)
        return
    }


    const story = new inkjs.Compiler(data).Compile();
    // story is an inkjs.Story that can be played right away

    const jsonBytecode = story.ToJson();
    // the generated json can be further re-used

    console.log(jsonBytecode)
})

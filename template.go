package main

import (
	"fmt"
	"os"
	"text/template"
)

type todoFileData struct {
	Root        string         `json:"root"`
	Branch      string         `json:"branch"`
	Author      string         `json:"author"`
	Project     string         `json:"project"`
	Emergencies []*ToDoComment `json:"emergencies"`
	Todos       []*ToDoComment `json:"todos"`
	Fixemes     []*ToDoComment `json:"fixmes"`
	Bugs        []*ToDoComment `json:"bugs"`
	Hacks       []*ToDoComment `json:"hacks"`
	Refs        []*ToDoComment `json:"refs"`
}

func createTodoFile(result result) error {
	outputPath := "TODO.md"
	tTodoFile := template.Must(template.New("todo").Parse(string(templateTasks)))
	todofile, err := os.Create(outputPath)
	if err != nil {
		if verboseFlag {
			fmt.Println("Error creating the template :", err)
		}
		return err
	}
	todoFileData := &todoFileData{
		Root:    result.Root,
		Branch:  result.Branch,
		Author:  result.Author,
		Project: result.Project,
	}
	return tTodoFile.Execute(todofile, todoFileData)
}

var (
	headerTable = `|title|body|file|line|`

	templateTasks = `# Tasks

## Information
* Root: {{ .Root }}
* Branch: {{ .Branch }}
* Revision: {{ .Revision }}
* Author: {{ .Author }}
* Project: {{ .Project }}

{{if .Urgent}}
### URGENT
{{ .HeaderTable }}
{{ end }}

{{if .Todo}}
### TODO
{{ .HeaderTable }}
{{ end }}

{{if .Fixme}}
### FIXME
{{ .HeaderTable }}
{{ end }}

{{if .Bug}}
### BUG
{{ .HeaderTable }}
{{ end }}

{{if .Hack}}
### HACK
{{ .HeaderTable }}
{{ end }}

{{if .Refs}}
### REFS
{{ .HeaderTable }}
{{ end }}
`
)

*** Settings ***
Documentation        Ações e lementos da página de cadastro de tarefas

Library    Browser

*** Keywords ***
Submit task form
    [Arguments]        ${task}

    Fill Text        css=input[placeholder$="tarefa"]        ${task}[name]
    Fill Text        css=input[placeholder="Informe até 3 tags"]        ${task}[tags]
    
    Click        css=button >> text=Cadastrar
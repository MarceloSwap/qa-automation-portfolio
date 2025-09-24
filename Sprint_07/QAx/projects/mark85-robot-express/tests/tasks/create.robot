*** Settings ***
Documentation        Cenário de cadastro de tarefas

Library         JSONLibrary

Resource        ../../resources/base.resource

*** Test Cases ***

CT008 Deve poder cadastrado uma nova tarefa
    [Tags]        CT008
    ${data}        Load Json From File        ${EXECDIR}/resources/fixtures/tasks.json
    Log            ${data}  
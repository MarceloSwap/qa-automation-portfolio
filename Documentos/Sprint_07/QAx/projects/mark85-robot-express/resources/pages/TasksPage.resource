*** Settings ***
Documentation        Ações e elementos da página de listagem de tarefas

Library        Browser

*** Keywords ***
Task should be registered
    [Arguments]        ${task_name}

    # Combina a classe e o texto pra conseguir filtrar no meio de várias tarefas
    Wait For Elements State    css=.task-todo >> text=${task_name}
    ...    visible    6
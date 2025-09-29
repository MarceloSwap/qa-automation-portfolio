*** Settings ***
Documentation        Cenário de cadastro de tarefas

Resource        ../../resources/base.resource

Test Setup        Start Session
Test Teardown     Take Screenshot

*** Test Cases ***

CT008 Deve poder cadastrado uma nova tarefa
    [Tags]        task
                    # Obtenção da massa
    ${data}        Get fixture        tasks    create

    # Exclui o user de teste e garante que ele terá os dados iniciais corretos para os testes
    Clean user form database        ${data}[user][email]
    Insert user from database       ${data}[user]
      
    Submit login form               ${data}[user]
    User should be logger in        ${data}[user][name]

    Go to task form
    Submit task form                ${data}[task]
    Task should be registered       ${data}[task][name]
    

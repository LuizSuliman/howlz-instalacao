#!/bin/bash

echo "   __  __                            ___    ________ "
echo "  /\ \/\ \                          /\_ \  /\_____  \ "
echo "  \ \ \_\ \      ___     __  __  __ \//\ \ \/____// / "
echo "   \ \  _  \    / __ \  /\ \/\ \/\ \  \ \ \     // / "
echo "    \ \ \ \ \  /\ \L\ \ \ \ \_/ \_/ \  \_\ \_  // /____ "
echo "     \ \_\ \_\ \ \____/  \ \___x___/   /\____\ /\_______\ "
echo "      \/_/\/_/  \/___/    \/__//__/    \/____/ \/_______/ "
echo
echo "Seja bem-vindo ao Instalador da HowlZ!"
echo "Vamos preparar o ambiente para a nossa aplicação."
echo
sleep 3

echo "A HowlZ precisa dos seguintes recursos:"
echo
echo "1. Sistema operacional atualizado"
echo "2. Java (JRE 17)"
echo "3. Docker (Container MySQL 5.7)"
echo "4. Aplicação Howlz (.jar)"
echo
echo "Não se preocupe, nós cuidamos da instalação destes componentes automaticamente"
echo "Por isso, é recomendado que você execute esse instalador com permissões de administrador (sudo)"
echo
echo "Deseja prosseguir com a instalação? (s/n)"
read getPermissao

if [ \"$getPermissao\" == \"s\" ]; then
    echo "Iniciando instalação..."

    echo "Atualizando sistema..."
    sudo apt update &>/dev/null && sudo apt upgrade -y &>/dev/null

    java -version &>/dev/null

    if [ $? == 0 ]; then
        echo "Java já está instalado."
    else
        echo "Java não instalado."
        echo "Instalando Java (JRE 17)..."

        sudo apt install openjdk-17-jre -y &>/dev/null
        echo "Java instalado."
    fi

    docker --version &>/dev/null

    if [ $? == 0 ]; then
        echo "Docker já está instalado."
    else
        echo "Docker não instalado."
        echo "Instalando Docker.io..."

        sudo apt install docker.io -y &>/dev/null
        echo "Docker instalado."
    fi

    echo "Configurando Ambiente da HowlZ..."
    mkdir ambiente_howlz

    # Entrando no diretório "AmbienteHowlZ"
    cd ambiente_howlz

    # Criando o arquivo .sql para o container MySQL
    wget https://github.com/LuizSuliman/howlz-instalacao/raw/main/script.sql &>/dev/null

    # Criando Dockerfile
    wget https://github.com/LuizSuliman/howlz-instalacao/raw/main/Dockerfile &>/dev/null

    sudo docker build -t banco-howlz . &>/dev/null
    sudo docker run -d --name container-howlz -p 3306:3306 banco-howlz &>/dev/null

    echo "Instalando Aplicação HowlZ..."
    wget https://github.com/LuizSuliman/howlz-instalacao/raw/main/howlz.jar &>/dev/null

    echo "Instalação finalizada!"
    echo "Deseja iniciar o aplicativo? (s/n)"

    read getIniciar
    if [ \"$getIniciar\" == \"s\" ]; then
        echo "Iniciando aplicativo..."
        sleep 2
        java -jar howlz.jar
    else
        echo "Ok! Obrigado por escolher a HowlZ!"
        sleep 2
    fi
else
    echo "Até a próxima!"
fi

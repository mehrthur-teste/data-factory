#!/bin/bash

echo "========================================"
echo "CRIANDO SOLUTION DDD EM .NET"
echo "========================================"

# Cria pasta raiz
mkdir Api
cd Api || exit

# Cria pasta src
mkdir src
cd src || exit

echo "Criando Solution..."
dotnet new sln -n Api

echo "Criando projetos..."

# Application (Web API)
dotnet new webapi -n Api.Application -o Api.Application --no-https --framework net10.0

# to install swagger dependencies
cd Api.Application || exit
dotnet add package Swashbuckle.AspNetCore --version 6.5.0
cd .. || exit


# Domain
dotnet new classlib -n Api.Domain -f net10.0 -o Api.Domain

# CrossCutting
dotnet new classlib -n Api.CrossCutting -f net10.0 -o Api.CrossCutting

# Data
dotnet new classlib -n Api.Data -f net10.0 -o Api.Data

# Service
dotnet new classlib -n Api.Service -f net10.0 -o Api.Service

echo "Adicionando projetos na Solution..."

dotnet sln add Api.Application/Api.Application.csproj
dotnet sln add Api.Domain/Api.Domain.csproj
dotnet sln add Api.CrossCutting/Api.CrossCutting.csproj
dotnet sln add Api.Data/Api.Data.csproj
dotnet sln add Api.Service/Api.Service.csproj

echo "Criando referências entre projetos..."

# Data -> Domain ✅
dotnet add Api.Data/Api.Data.csproj reference Api.Domain/Api.Domain.csproj

# Service -> Domain ✅
dotnet add Api.Service/Api.Service.csproj reference Api.Domain/Api.Domain.csproj

# CrossCutting -> Domain, Service ✅
dotnet add Api.CrossCutting/Api.CrossCutting.csproj reference Api.Domain/Api.Domain.csproj
dotnet add Api.CrossCutting/Api.CrossCutting.csproj reference Api.Service/Api.Service.csproj

# Application -> Domain, Service, CrossCutting ✅
dotnet add Api.Application/Api.Application.csproj reference Api.Domain/Api.Domain.csproj
dotnet add Api.Application/Api.Application.csproj reference Api.Service/Api.Service.csproj
dotnet add Api.Application/Api.Application.csproj reference Api.CrossCutting/Api.CrossCutting.csproj


echo "Buildando a Solution..."
dotnet build

echo "========================================"
echo "✅ SOLUTION CRIADA COM SUCESSO!"
echo "========================================"



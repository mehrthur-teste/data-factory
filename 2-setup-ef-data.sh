#!/bin/bash

echo "========================================"
echo "CONFIGURANDO ENTITY FRAMEWORK NA Api.Data"
echo "========================================"

# Verifica se está na pasta correta
if [ ! -d "Api/src/Api.Data" ]; then
  echo "❌ Pasta Api/src/Api.Data não encontrada!"
  echo "Execute esse script na raiz onde existe a pasta Api/"
  exit 1
fi

cd Api/src/Api.Data || exit

echo "Instalando pacotes do Entity Framework Core (SQL Server)..."

dotnet add package Microsoft.EntityFrameworkCore --version 8.0.0
dotnet add package Microsoft.EntityFrameworkCore.Design --version 8.0.0
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 8.0.0
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 8.0.0

echo "Instalando provedor MySQL (Pomelo)..."
dotnet add package Pomelo.EntityFrameworkCore.MySql --version 8.0.0

echo "Criando estrutura de pastas do EF..."

mkdir -p Context
mkdir -p Mapping
mkdir -p Repository

echo "Verificando referência com Api.Domain..."

dotnet add reference ../Api.Domain/Api.Domain.csproj

echo "Entity Framework configurado com sucesso na Api.Data ✅"
echo "========================================"

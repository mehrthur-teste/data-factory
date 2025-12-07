#!/bin/bash

echo "========================================"
echo "CRIANDO MIGRATION E BANCO"
echo "========================================"

cd Api/src/Api.Data || exit

dotnet ef migrations add InitialMigration -s ../Api.Application
dotnet ef database update -s ../Api.Application

echo "✅ Migration criada e banco atualizado!"

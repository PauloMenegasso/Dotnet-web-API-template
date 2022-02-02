@echo off
SET downloadPackages = True

cd C:\Users\user\Desktop
mkdir %1
cd %1

mkdir scr
cd scr

dotnet new webapi -n %1 -o Api

dotnet new classlib -n %1.Business -o Business
dotnet new classlib -n %1.Infra -o Infra
dotnet new classlib -n %1.Domain -o Domain

cd Domain
del /f Class1.cs
mkdir Entities
if %2==True dotnet add package Newtonsoft.Json --version 13.0.1
cd..

cd Infra
del /f Class1.cs
mkdir Services
mkdir Databases
dotnet add %1.Infra.csproj reference ../Domain/%1.Domain.csproj
if %2==T dotnet add package Dapper --version 2.0.123
if %2==T dotnet add package Dapper.Extensions.NetCore --version 4.0.2
if %2==T dotnet add package Dapper.SimpleCRUD --version 2.3.0
if %2==T dotnet add package Polly --version 7.2.3
if %2==T dotnet add package RestSharp --version 107.1.3-alpha.0.2
if %2==T dotnet add package Newtonsoft.Json --version 13.0.1
cd..

cd Business
del /f Class1.cs
dotnet add %1.Business.csproj reference ../Domain/%1.Domain.csproj
dotnet add %1.Business.csproj reference ../Infra/%1.Infra.csproj
cd..

cd Api
dotnet add %1.csproj reference ../Domain/%1.Domain.csproj
dotnet add %1.csproj reference ../Business/%1.Business.csproj
dotnet add %1.csproj reference ../Infra/%1.Infra.csproj
cd..

cd..
dotnet new xunit -n %1.Tests -o tests

cd tests
dotnet add %1.Tests.csproj reference ../scr/Api/%1.csproj
if %3==T dotnet add package AutoBogus --version 2.13.1
if %3==T dotnet add package AutoBogus.NSubstitute --version 2.13.1
if %3==T dotnet add package NSubstitute --version 4.3.0

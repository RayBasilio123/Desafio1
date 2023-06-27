#!/bin/bash
#caminho = /home/servidor/Downloads

if [ ! -d cadastros_partes-csv ]
then
    mkdir cadastros_partes-csv
fi

if [ ! -d cadastros_partes-txt ]
then
    mkdir cadastros_partes-txt
fi
if [ ! -d cadastros_partes-pdf ]
then
    mkdir cadastros_partes-pdf
fi

converte_csv(){
cat cadastros.csv | parallel --header : --pipe -N100 'cat >cadastros_partes-csv/cadastro{#}.csv'
}
converte_txt(){
for cadastros in cadastros_partes-csv/cadastro*
do
	while read line
	do
	   echo -n -e ${line//,/"\t"} >> $(ls $cadastros |awk -F. '{print $1}').txt 
	done < $cadastros
	mv cadastros_partes-csv/*.txt cadastros_partes-txt	
done
}




converte_pdf(){
for cadastro in "cadastros_partes-txt"/*
do

	soffice --headless --convert-to pdf $cadastro
    
done
mv *.pdf cadastros_partes-pdf
}
cria_pastas(){
for cadastro in "cadastros_partes-pdf"/*
do
	cadastro_name=$(ls $cadastro |awk -F. '{print $1}')
	if [ ! -d  $cadastro_name ]
	then
		mkdir $cadastro_name
	fi	
    
done
}

move_cadastros(){
for cadastro in "cadastros_partes-pdf"/*
do
	cadastro_name=$(ls $cadastro |awk -F. '{print $1}')
	mv $cadastro_name.pdf $cadastro_name
    
done
}

converte_csv
if [ $? -eq 0 ]
then
    echo "Os arquivos foram separados com sucesso no formato csv"
else
    echo "Houve um problema na hora de separar os arquivos no formato csv"
fi

converte_txt
if [ $? -eq 0 ]
then
    echo "Os arquivos foram separados com sucesso no formato txt"
else
    echo "Houve um problema na hora de separar os arquivos no formato txt"
fi

converte_pdf
if [ $? -eq 0 ]
then
    echo "Os arquivos foram salvos em pdf com sucesso"
else
    echo "Houve um problema na hora de salvar os arquivos em pdf"
fi

cria_pastas
if [ $? -eq 0 ]
then
    echo "As pastas foram criadas com sucesso"
else
    echo "Houve um problema na hora de criar as pastas"
fi

move_cadastros

if [ $? -eq 0 ]
then
    echo "Os arquivos pdfs foram movidos com sucesso"
else
    echo "Houve um problema na hora de mover os pdfs"
fi





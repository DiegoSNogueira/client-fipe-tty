require 'tty-prompt'
require 'tty-table'
require 'rest-client'
require 'json'

system 'clear'
# lista de marcas
url = 'https://parallelum.com.br/fipe/api/v1/carros/marcas'
resp = RestClient.get url.to_s
marcas = JSON.parse(resp.body)
marca = marcas.map { |i| i['nome'] }

# Escolha da marca
prompt = TTY::Prompt.new
escolha_marca = prompt.select('Escolha a marca do veículo?', marca)

marca_id = marcas.select { |i| i if i['nome'] == escolha_marca }.map { |n| n['codigo'] }[0]

# lista de modelos
url = "https://parallelum.com.br/fipe/api/v1/carros/marcas/#{marca_id}/modelos"

resp = RestClient.get url.to_s
modelos = JSON.parse(resp.body)
modelo = modelos['modelos'].map { |i| i['nome'] }

# x = modelos["modelos"].map { |i| { :nome =>i["nome"], :codigo => i["codigo"] } }

# Escolha da marca
escolha_modelo = prompt.select('Escolha o modelo?', modelo)
modelo_id = modelos['modelos'].select { |i| i if i['nome'] == escolha_modelo }.map { |n| n['codigo'] }[0]

# lista anos
url = "https://parallelum.com.br/fipe/api/v1/carros/marcas/#{marca_id}/modelos/#{modelo_id}/anos"
resp = RestClient.get url.to_s
anos = JSON.parse(resp.body)

ano = anos.map { |i| i['nome'] }

escolha_ano = prompt.select('Escolha o ano?', ano)
ano_id = anos.select { |i| i if i['nome'] == escolha_ano }.map { |n| n['codigo'] }[0]

# Lista valor
url = "https://parallelum.com.br/fipe/api/v1/carros/marcas/#{marca_id}/modelos/#{modelo_id}/anos/#{ano_id}"
resp = RestClient.get url.to_s
valor = JSON.parse(resp.body)

table = TTY::Table.new do |t|
  valor.each do |key, value|
    t << [key, value]
  end
end

puts table.render(:ascii)


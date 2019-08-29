//
//  AttractionTableViewController.swift
//  PontosTuristicos
//
//  Created by Lilian Tatsumy Yamamoto Kishi on 08/03/2019.
//  Copyright © 2019 Satoru Kishi. All rights reserved.
//

import UIKit
import Foundation

class AtractionTablewViewController : UITableViewController {
    
    //Objeto que conterá o conjunto de Atrações que será usado na tableview
    var dataSource: [Attraction] = []
    
    //Criando nossa label que será a backgroundView da tabela
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocalJSON() //Alimentando nosso dataSource
        
        tableView.estimatedRowHeight = 53  //Definindo um tamanho base para o cálculo do tamanho final
        tableView.rowHeight = UITableView.automaticDimension //Definindo que o tamanho será dinâmico
        
        //Definindo os valores das propriedades da lavel
        label.text = "Atrações não cadastradas"
        label.textAlignment = .center
        label.textColor = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AttractionMapViewController
        vc.attraction = dataSource[tableView.indexPathForSelectedRow!.row]
    }
    
    
    //Método que fará a leitura (parse) do JSON e alimentará o objeto dataSource
    func loadLocalJSON() {
        
        //Recuperando URL onde se encontra localmente o arquivo movies.json
        if let jsonURL = Bundle.main.url(forResource: "attractions", withExtension: "json") {
            
            //Gerando arquivo Data a partir do arquivo JSON
            let data: Data = try! Data(contentsOf: jsonURL)
            
            //Deserializando o JSON e convertendo em Array de Dicionários. Usamos o objeto data
            //contendo o JSON e .ReadingOptions() como valor padrão de leitura e tratamento desse JSON
            let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [[String: Any]]
            
            for item in json {  //Percorrendo Array de itens do json
                
                //Recuperando informações do JSON e convertendo em objetos locais
                let title = item["title"] as! String
                let address = item["address"] as! String
                
                //Criando objeto Attraction a partir das informações extraídas do JSON
                let attraction = Attraction(title: title, address: address)
                
                dataSource.append(attraction)    //Alimentando array de Attraction (dataSource)
            }
            tableView.reloadData()  //Método usado para recarregar os itens de uma tabela
        }
    }
    
    // MARK: - Table view data source
    
    //Método que define a quantidade de seções de uma tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Método que define a quantidade de células para cada seção de uma tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Caso nosso dataSource seja 0, teremos a label aparecendo.
        tableView.backgroundView = dataSource.count == 0 ? label : nil
        
        return dataSource.count //Retornamos o total de itens no nosso dataSource
    }
    
    //Método que define a célula que será apresentada em cada linha
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Definimos o identifier que usamos em nossa célula (attractionCell)
        //Fazemos o cast para AttractionTableViewCell para que possamos acessar os
        //IBOutlets criados
        let cell = tableView.dequeueReusableCell(withIdentifier: "attractionCell", for: indexPath) as! AttractionTableViewCell
        
        //Atribuindo os valores de acordo com os dados recuperados de cada Attraction
        //Recuperamos o Movie usando a propriedade row do indexPath da célula em questão
        cell.lbAddress.text = dataSource[indexPath.row].address
        cell.lbTitulo.text = dataSource[indexPath.row].title
        
        return cell
    }
    
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            dataSource.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
}

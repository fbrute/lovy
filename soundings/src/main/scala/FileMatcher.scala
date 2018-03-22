// Auteur : France-Nor Brute
// Copyright : Mars 2018
// Projet TephiLov
//
// Ce fichier recense et exécute les requêtes sqls nécessaires pour la génération des courbes tephis
//
object FileMatcher {

  def filesHere = (new java.io.File("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/soundings/src/main/sql/tephi")).listFiles

  def filesEnding(query: String) =
    for (file <- filesHere; if file.getName.endsWith(query))
      yield file
}



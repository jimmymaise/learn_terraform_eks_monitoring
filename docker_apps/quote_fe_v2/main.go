package main

import (
	"encoding/json"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"

)

type Quote struct {
	Author string `json:"author"`
	Text   string `json:"text"`
}

type QuotePageData struct {
	PageTitle string
	Quotes    []Quote
}

type QuoteResponse []Quote

func main() {

	resp, getErr := http.Get("https://type.fit/api/quotes")
	if getErr != nil {
		log.Fatal(getErr)
	}

	body, readErr := ioutil.ReadAll(resp.Body)
	if readErr != nil {
		log.Fatal(readErr)
	}
	var quotes QuoteResponse
	err := json.Unmarshal([]byte(body), &quotes)
	if err != nil {
		panic(err)
	}

	tmpl := template.Must(template.ParseFiles("layout.html"))
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		data := QuotePageData{
			PageTitle: "Hi this is the version 2 using Golang. This version will display 10 quotes",
			Quotes:    quotes[0:10],
		}
		tmpl.Execute(w, data)
	})
	http.ListenAndServe(":8080", nil)
}

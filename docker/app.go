package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"

	"golang.org/x/net/html"
)

type scrapeDataStore struct {
	Internal int `json:"internal"`
	External int `json:"external"`
}

func isInternal(parsedLink *url.URL, siteURL *url.URL, link string) bool {
	return parsedLink.Host == siteURL.Host || strings.Index(link, "#") == 0 || len(parsedLink.Host) == 0
}

func main() {
	// 获取操作系统环境环境
	urlIn := os.Getenv("url")
	if len(urlIn) == 0 {
		urlIn = "https://www.cnblogs.com/"
		log.Fatalln("Need a valid url as an env-var.")
	}
	// url解析
	siteURL, parseErr := url.Parse(urlIn)
	if parseErr != nil {
		log.Fatalln(parseErr)
	}
	// 发起 http get请求
	resp, err := http.Get(urlIn)
	if err != nil {
		log.Fatalln(err)
	}

	//
	scrapeData := &scrapeDataStore{}
	tokenizer := html.NewTokenizer(resp.Body)
	end := false
	for {
		tt := tokenizer.Next()
		switch {
		case tt == html.StartTagToken:
			// fmt.Println(tt)
			token := tokenizer.Token()
			switch token.Data {
			case "a":

				for _, attr := range token.Attr {

					if attr.Key == "href" {
						link := attr.Val

						parsedLink, parseLinkErr := url.Parse(link)
						if parseLinkErr == nil {
							if isInternal(parsedLink, siteURL, link) {
								scrapeData.Internal++
							} else {
								scrapeData.External++
							}
						}

						if parseLinkErr != nil {
							fmt.Println("Can't parse: " + token.Data)
						}
					}
				}
				break
			}
		case tt == html.ErrorToken:
			end = true
			break
		}
		if end {
			break
		}
	}
	data, _ := json.Marshal(&scrapeData)
	fmt.Println(string(data))
}

import React from 'react';
import NewsCard from './NewsCard';
import {  Alert } from 'react-bootstrap';

const TopNews = ({ newsData }) => {
    console.log("NewsData", newsData);

    const topNews = [];
    let count = 0;

    // Iterate over the newsData array
    for (let i = 0; i < newsData.length; i++) {
        const news = newsData[i];
        
        // Check if the news object contains all required fields and isConfirmed
        if (
            // news.image != " " &&
            // // news.title &&
            // // news.datetime &&
            // news.summary != " " 
            // // news.url &&
            // // news.source
            news.image && // Check if image exists
    news.image.trim() !== "" && // Check if image is not empty
    news.summary && // Check if summary exists
    news.summary.trim() !== "" 
            
        ) {
            // Add the news to the topNews array
            topNews.push(news);
            count++;

            // If we have found 20 news articles, stop iterating
            if (count === 20) {
                break;
            }
        }
    }


 return (
     <div className="row">
         {/* First Column */}
         {topNews.length === 0 ? (
        <Alert variant="info" style={{textAlign:'center'}}>No news to display</Alert>):(<>
             {topNews.map((news, index) => (
                         <div className="col-lg-6 col-md-12 mb-3">
                 <NewsCard
                     key={index} // Ensure each card has a unique key
                     news={news}
                 />
                  </div>
             ))}</>)}
        
         {/* Second Column */}
         {/* <div className="col-md-6">
             {secondColumnNews.map((news, index) => (
                 <NewsCard
                     key={index + 10} // Ensure each card has a unique key
                     news={news}
                 />
             ))}
         </div> */}
     </div>
 );
}

export default TopNews;

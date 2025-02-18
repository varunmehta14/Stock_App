import React from 'react';
import RecommendationsChart from './RecommendationsChart';
import EarningsChart from './EarningsChart';

const Insights = ({ sentimentData, earningsData, recommendationsData }) => {
  // Initialize total, positive, and negative variables for mspr and change
  let msprTotal = 0;
  let msprPositive = 0;
  let msprNegative = 0;
  let changeTotal = 0;
  let changePositive = 0;
  let changeNegative = 0;

  // Iterate over the sentimentData array and accumulate values
  sentimentData.data.forEach((data) => {
    msprTotal += data.mspr;
    changeTotal += data.change;
    if (data.mspr > 0) {
      msprPositive += data.mspr;
    } else if (data.mspr < 0) {
      msprNegative += data.mspr;
    }
    if (data.change > 0) {
      changePositive += data.change;
    } else if (data.change < 0) {
      changeNegative += data.change;
    }
  });

  return (
    <div className="container text-center">
      <h2>Insider Sentiments</h2>
      <div className="table-responsive col-md-6 mx-auto" >
        <table className="table">
          <thead>
            <tr>
              <th>{sentimentData.symbol}</th>
              <th>MSPR</th>
              <th>Change</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Total</td>
              <td>{msprTotal.toFixed(2)}</td>
              <td>{changeTotal.toFixed(2)}</td>
            </tr>
            <tr>
              <td>Positive</td>
              <td>{msprPositive.toFixed(2)}</td>
              <td>{changePositive.toFixed(2)}</td>
            </tr>
            <tr>
              <td>Negative</td>
              <td>{msprNegative.toFixed(2)}</td>
              <td>{changeNegative.toFixed(2)}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div className="row">
        {/* For larger screens, render both charts in two columns */}
        <div className="col-md-6">
          {recommendationsData !== undefined && <RecommendationsChart recommendationData={recommendationsData} />}
        </div>
        <div className="col-md-6">
          <EarningsChart earningsData={earningsData}/>
        </div>
        
        {/* For smaller screens, render each chart in its own row */}
        <div className="col-12 d-none d-md-none">
          {recommendationsData !== undefined && <RecommendationsChart recommendationData={recommendationsData} />}
        </div>
        <div className="col-12 d-none d-md-none">
          <EarningsChart earningsData={earningsData}/>
        </div>
      </div>
    </div>
  );
};

export default Insights;

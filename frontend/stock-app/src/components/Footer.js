import React from 'react';

function Footer() {
  return (
    <footer className="footer mt-auto py-3 " style={{backgroundColor:"#d7d7d7",position: "fixed", bottom: "0", width: "100%",padding: '20px' }} >
      <div className="container d-flex align-items-center justify-content-center">
        <span className="text-muted"><b>Powered by <a href="https://finnhub.io" target="_blank">Finnhub.io</a></b></span>
      </div>
    </footer>
  );
}

export default Footer;


import React, { useState } from 'react';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import Modal from 'react-bootstrap/Modal'; // Import React Bootstrap Modal
import { shareOnTwitter, shareOnFacebook } from '../../../utils/socialMedia'; // Import functions to share on social media
import './NewsCard.css';
import XIcon from '@mui/icons-material/X';
import FacebookIcon from '@mui/icons-material/Facebook';
import { IconButton } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faFacebookSquare } from '@fortawesome/free-brands-svg-icons';

const NewsCard = ({ news }) => {
  const [showModal, setShowModal] = useState(false); // State to control modal visibility

  const handleOpenModal = () => {
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
  };

  const formatDate = (timestamp) => {
    // Convert epoch timestamp to milliseconds
    const milliseconds = timestamp * 1000;
    const date = new Date(milliseconds);
    const options = { month: 'long', day: 'numeric', year: 'numeric' };
    return date.toLocaleDateString('en-US', options);
  };

  const handleShareOnTwitter = () => {
    shareOnTwitter(news.headline, news.url);
  };

  const handleShareOnFacebook = () => {
    shareOnFacebook(news.url);
  };

  return (
    <>
      <div className="card mb-3 custom-card " onClick={handleOpenModal} centered style={{ top: '0', left: '50%', transform: 'translateX(-50%)' }}>
        <div className="row g-0">
          <div className="col-lg-4 col-md-12">
          <div className="card-image-container">
    <img src={news.image} alt={news.related} className="card-image-md" />
  </div>
          </div>
          <div className="col-lg-8 col-md-12">
            <div className="card-body">
              <p style={{textAlign:'center', fontSize:'14px'}}>{news.headline}</p>
            </div>
          </div>
        </div>
      </div>
      <Modal show={showModal} onHide={handleCloseModal}  >
      <Modal.Header closeButton>
        <Modal.Title>
          <div>{news.source}</div>
          <div style={{color:'gray'}}><h6>{formatDate(news.datetime)}</h6></div>
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Typography variant="body1" style={{ fontWeight: 'bold' }}>
          {news.summary}
        </Typography>
        <Typography variant="body1">
          For more details click{' '}
          <a href={news.url} target="_blank" rel="noopener noreferrer">
            here
          </a>
        </Typography>
        <div className='card' style={{padding:'20px',marginTop:'25px'}}>
          <p>Share</p>
          <div style={{display:"flex",justifyContent:"left"}}>
        <IconButton onClick={handleShareOnTwitter} variant="outline-primary">
          <XIcon />
        </IconButton>
        <IconButton onClick={handleShareOnFacebook} variant="outline-primary">
         
          <FontAwesomeIcon icon={faFacebookSquare} style={{color:"#1877F2"}} size="lg"/>
        </IconButton>
        </div>
        </div>
      </Modal.Body>
      {/* <Modal.Footer style={{ border: '1px solid #ccc', justifyContent: 'left' }}> */}
       
      {/* </Modal.Footer> */}
    </Modal>
    </>
  );
};

export default NewsCard;


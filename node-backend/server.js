const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql2');

const app = express();
const PORT = 8201;
const db = mysql.createConnection({
    host: '45.127.6.146',
    user: 'alpha',
    password: 'mS9a8p0*6',
    database: 'alpha'
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err.stack);
        return;
    }
    console.log('Connected to the database');
});

app.use(cors());
app.use(bodyParser.json());


app.get('/', (req, res) => {
    res.send('Hello from Node.js Backend!');
});

app.post('/check-username', (req, res) => {
    const { username } = req.body;

    // Query the database to check if the username exists
    const query = 'SELECT COUNT(*) AS count FROM users WHERE username = ?';
    db.query(query, [username], (err, results) => {
        if (err) {
            console.error('Error checking username:', err);
            return res.status(500).json({ error: 'Database error' });
        }

        if (results[0].count > 0) {
            return res.status(400).json({ error: 'Username already exists' });
        } else {
            const insertQuery = 'INSERT INTO users (username) VALUES (?)';
            db.query(insertQuery, [username], (err, insertResults) => {
                if (err) {
                    console.error('Error inserting username:', err);
                    return res.status(500).json({ error: 'Database error during insert' });
                }

                const userId = insertResults.insertId;
                return res.status(200).json({ message: 'Username is available', userId: userId });
            });
        }
    });
});

app.post('/login', (req, res) => {
    const { username } = req.body;

    // Query the database to check if the username exists
    const query = 'SELECT * FROM users WHERE username = ?';
    db.query(query, [username], (err, results) => {
        if (err) {
            console.error('Error checking username:', err);
            return res.status(500).json({ error: 'Database error' });
        }

        if (results.length > 0) {
            const userId = results[0].id;
            return res.status(200).json({
                message: 'Username logged in',
                userId: userId
            });
        } else {
            return res.status(400).json({ error: 'Username does not exist' });
        }
    });
});

app.post('/save-canvas', (req, res) => {
    const { name, data, user_id } = req.body;
    const query = 'INSERT INTO canvas (canvas_name, data, user_id) VALUES (?, ?, ?)';
    db.query(query, [name, data, user_id], (err, result) => {
      if (err) {
        console.error(err);
        res.status(500).send('Error saving grid data.');
      } else {
        res.status(200).send('Grid saved successfully.');
      }
    });
  });
  
 
  app.get('/get-canvas-list/:user_id', (req, res) => {
    const { user_id } = req.params;
    const query = 'SELECT id, canvas_name FROM canvas where user_id = ?';
    db.query(query, [user_id], (err, results) => {
      if (err) {
        console.error(err);
        res.status(500).send('Error fetching grid list.');
      } else {
        res.status(200).json(results);
      }
    });
  });
  
  
  app.get('/canvas/:id', (req, res) => {
    const { id } = req.params;
    const query = 'SELECT data FROM canvas WHERE id = ?';
    db.query(query, [id], (err, result) => {
      if (err) {
        console.error(err);
        res.status(500).send('Error fetching grid data.');
      } else {
        res.status(200).json(result[0]);
      }
    });
  });

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
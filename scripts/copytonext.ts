import {initializeApp, cert} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
import * as fs from "node:fs";


const serviceAccount = require('/Users/christiankrutsche/Downloads/Mladezovy Zpevnik Firebase Service Account.json');

initializeApp({
    credential: cert(serviceAccount),
    databaseURL: 'https://mladezovy-zpevnik.firebaseio.com',
    projectId: 'mladezovy-zpevnik',
});

const backup = async () => {
    await getFirestore().listCollections() // avoids timeout
    const songsCollection = await getFirestore().collection('songs_next');
    const songsData = JSON.parse(fs.readFileSync('data.json', 'utf-8'))
    songsData.forEach(song => {
        songsCollection.add(song)
    })
}

backup()

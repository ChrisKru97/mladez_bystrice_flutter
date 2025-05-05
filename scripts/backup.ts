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
    const songs = await getFirestore()
        .collection('songs')
        .orderBy('number', 'asc')
        .get();
    const songsData = songs.docs.map(doc => {
        const {number, withChords, name} = doc.data()
        return {number, text:withChords, name}
    })
    console.log(songsData[0])
    fs.writeFileSync('data.json', JSON.stringify(songsData, null, 2), 'utf-8')
}

backup()

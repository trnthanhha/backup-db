const { execute } = require('@getvim/execute');
const dotenv = require('dotenv');
const cron = require('node-cron');
dotenv.config();
const DB_PASSWORD = process.env.DB_PASSWORD;
const DB_USER = process.env.DB_USER;
const DB_NAME = process.env.DB_NAME;
const DB_HOST = process.env.DB_HOST;
const DB_PORT = process.env.DB_PORT;
const backupWeekly = () => {
  const now = new Date();
  const date = now.getDate() + '-' + now.getMonth() + '-' + now.getFullYear();
  execute(
    `PGPASSWORD="${DB_PASSWORD}" pg_dump -U ${DB_USER} -h ${DB_HOST} -p ${DB_PORT} -d ${DB_NAME} -f backup/${date}database-backup.pgsql`,
  )
    .then(() => {
      console.log('Success');
    })
    .catch((e) => {
      console.log(e);
    });
};

cron.schedule('0 0 0 * * 0 ', () => {
  backupWeekly();
});

// `ssh root@..."PGPASSWORD=${DB_PASSWORD} pg_dump -U ${DB_USER} -h ${DB_HOST} -p ${DB_PORT} -d ${DB_NAME} -C" \ > database-backup.pgsql`,

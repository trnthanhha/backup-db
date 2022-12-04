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
  const date =
    now.getHours() +
    'h -' +
    now.getDate() +
    '-' +
    now.getMonth() +
    '-' +
    now.getFullYear();
  execute(
    `PGPASSWORD="${DB_PASSWORD}" pg_dump -U ${DB_USER} -h ${DB_HOST} -p ${DB_PORT} -d ${DB_NAME} -f backup/${date}-database-backup.pgsql`,
  )
    .then(() => {
      console.log(`create file backup: ${date} Success`);
    })
    .catch((e) => {
      console.log(e);
    });
};
console.log('start cron backup DB weekly');
cron.schedule('0 0 */1 * * * ', () => {
  backupWeekly();
});

// `ssh root@..."PGPASSWORD=${DB_PASSWORD} pg_dump -U ${DB_USER} -h ${DB_HOST} -p ${DB_PORT} -d ${DB_NAME} -C" \ > database-backup.pgsql`,

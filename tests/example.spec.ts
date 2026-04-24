import { test, expect } from '@playwright/test';

test('has title', async ({ page }) => {
  await page.goto('https://playwright.dev/');

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Playwright/);
});

test('get started link', async ({ page }) => {
  await page.goto('https://playwright.dev/');

  // Click the get started link.
  await page.getByRole('link', { name: 'Get started' }).click();

  // Expects page to have a heading with the name of Installation.
  await expect(page.getByRole('heading', { name: 'Installation' })).toBeVisible();
});

test('log in', async ({ page }) => {
  // Open login account page
  await page.goto('http://localhost:9292/accounts/login');
  // Enter name and password
  await page.getByLabel('Name').fill('ola');
  await page.getByLabel('Password').fill('123');
  // Click login button
  await page.getByRole('button', { name: 'Login' }).click();
  // Expects to be logged in
  await expect(page.getByText('Logged in as:')).toBeVisible();
});

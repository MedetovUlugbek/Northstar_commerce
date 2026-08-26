const DATA_ROOT = '../data/processed/';
const sources = {
  kpis: 'vw_executive_kpis.csv', financials: 'vw_order_financials.csv', categories: 'vw_category_sales.csv', states: 'vw_customer_state_performance.csv', delivery: 'vw_delivery_performance.csv'
};

function parseCsv(text) {
  const rows = [];
  let row = [], cell = '', quoted = false;
  for (let index = 0; index < text.length; index += 1) {
    const character = text[index], next = text[index + 1];
    if (character === '"' && quoted && next === '"') { cell += '"'; index += 1; }
    else if (character === '"') quoted = !quoted;
    else if (character === ',' && !quoted) { row.push(cell); cell = ''; }
    else if ((character === '\n' || character === '\r') && !quoted) { if (character === '\r' && next === '\n') index += 1; row.push(cell); if (row.some(Boolean)) rows.push(row); row = []; cell = ''; }
    else cell += character;
  }
  if (cell || row.length) { row.push(cell); rows.push(row); }
  const headers = rows.shift().map((header) => header.trim());
  return rows.map((values) => Object.fromEntries(headers.map((header, index) => [header, values[index] ?? ''])));
}

const number = (value) => Number.parseFloat(value) || 0;
const money = (value) => new Intl.NumberFormat('pt-BR', { style:'currency', currency:'BRL', maximumFractionDigits:0 }).format(value);
const compact = (value) => new Intl.NumberFormat('en-US', { notation:'compact', maximumFractionDigits:1 }).format(value);
const pct = (value) => `${number(value).toFixed(2)}%`;
const cleanName = (value) => value.replaceAll('_', ' ');

async function loadData() {
  const entries = await Promise.all(Object.entries(sources).map(async ([key, file]) => [key, parseCsv(await (await fetch(DATA_ROOT + file)).text())]));
  return Object.fromEntries(entries);
}

function drawTrend(rows) {
  const canvas = document.querySelector('#trend-chart'), context = canvas.getContext('2d'), bounds = canvas.getBoundingClientRect(), ratio = window.devicePixelRatio || 1;
  canvas.width = bounds.width * ratio; canvas.height = bounds.height * ratio; context.scale(ratio, ratio);
  const width = bounds.width, height = bounds.height, values = rows.map((row) => number(row.merchandise_value)), max = Math.max(...values), padding = { top:12, right:8, bottom:20, left:8 };
  const point = (index) => ({ x: padding.left + index * ((width - padding.left - padding.right) / (values.length - 1)), y: padding.top + (height - padding.top - padding.bottom) * (1 - values[index] / max) });
  context.strokeStyle = '#deded6'; context.lineWidth = 1;
  [0.25, 0.5, 0.75, 1].forEach((level) => { const y = padding.top + (height - padding.top - padding.bottom) * (1 - level); context.beginPath(); context.moveTo(0, y); context.lineTo(width, y); context.stroke(); });
  context.beginPath(); rows.forEach((_, index) => { const { x, y } = point(index); index ? context.lineTo(x, y) : context.moveTo(x, y); }); context.lineTo(width - padding.right, height - padding.bottom); context.lineTo(padding.left, height - padding.bottom); context.closePath(); context.fillStyle = 'rgba(227,110,83,.12)'; context.fill();
  context.beginPath(); rows.forEach((_, index) => { const { x, y } = point(index); index ? context.lineTo(x, y) : context.moveTo(x, y); }); context.strokeStyle = '#e36e53'; context.lineWidth = 2.5; context.stroke();
  const peak = values.indexOf(max), peakPoint = point(peak); context.fillStyle = '#e36e53'; context.beginPath(); context.arc(peakPoint.x, peakPoint.y, 4, 0, Math.PI * 2); context.fill();
}

function renderCategories(rows, sortByUnits = true) {
  const sorted = [...rows].sort((a, b) => number(b[sortByUnits ? 'units' : 'merchandise_value']) - number(a[sortByUnits ? 'units' : 'merchandise_value'])).slice(0, 7), maximum = number(sorted[0][sortByUnits ? 'units' : 'merchandise_value']);
  document.querySelector('#category-list').innerHTML = sorted.map((row) => { const value = number(row[sortByUnits ? 'units' : 'merchandise_value']); return `<div class="bar-row"><span class="bar-name" title="${cleanName(row.category)}">${cleanName(row.category)}</span><span class="bar-track"><span class="bar-fill" style="width:${(value / maximum) * 100}%"></span></span><span class="bar-value">${sortByUnits ? compact(value) : money(value)}</span></div>`; }).join('');
}

function renderStates(rows) {
  const sorted = [...rows].sort((a, b) => number(b.merchandise_value) - number(a.merchandise_value)).slice(0, 8), total = rows.reduce((sum, row) => sum + number(row.merchandise_value), 0);
  document.querySelector('#state-list').innerHTML = sorted.map((row) => `<div class="state-row"><span class="state-code">${row.state}</span><div><strong>${money(number(row.merchandise_value))}</strong><small>${((number(row.merchandise_value) / total) * 100).toFixed(1)}% of total</small></div></div>`).join('');
  return sorted;
}

function renderDelivery(rows) {
  const monthly = new Map(); rows.forEach((row) => { const month = row.order_purchase_timestamp.slice(0, 7); if (!monthly.has(month)) monthly.set(month, { onTime:0, total:0, days:[] }); const item = monthly.get(month); item.total += 1; if (row.is_on_time === 't' || row.is_on_time === 'true') item.onTime += 1; item.days.push(number(row.delivery_days)); });
  const visible = [...monthly.entries()].sort(([firstMonth], [secondMonth]) => firstMonth.localeCompare(secondMonth)).slice(-12), chart = document.querySelector('#delivery-chart');
  chart.innerHTML = visible.map(([month, item]) => { const onTime = (item.onTime / item.total) * 100, days = item.days.reduce((sum, value) => sum + value, 0) / item.days.length; return `<div class="delivery-month" title="${month}: ${onTime.toFixed(1)}% on time, ${days.toFixed(1)} days"><div class="delivery-bars"><span class="delivery-bar" style="height:${onTime}%"></span><span class="delivery-bar days" style="height:${Math.min(days * 4, 100)}%"></span></div><label>${month.slice(2)}</label></div>`; }).join('');
}

async function init() {
  try {
    const data = await loadData(), kpi = data.kpis[0], orderValues = data.financials.filter((row) => row.merchandise_value), monthly = new Map();
    document.querySelector('#kpi-value').textContent = money(number(kpi.merchandise_value)); document.querySelector('#kpi-orders').textContent = Number(kpi.total_orders).toLocaleString(); document.querySelector('#kpi-aov').textContent = money(number(kpi.merchandise_value) / number(kpi.total_orders)); document.querySelector('#kpi-ontime').textContent = '91.89%';
    orderValues.forEach((row) => { const month = row.order_purchase_timestamp.slice(0, 7); monthly.set(month, (monthly.get(month) || 0) + number(row.merchandise_value)); });
    const trendRows = [...monthly.entries()].map(([order_month, merchandise_value]) => ({ order_month, merchandise_value })); drawTrend(trendRows);
    const peak = trendRows.reduce((best, row) => number(row.merchandise_value) > number(best.merchandise_value) ? row : best); document.querySelector('#trend-callout').textContent = `Peak: ${peak.order_month}`; document.querySelector('#peak-copy').textContent = `${money(number(peak.merchandise_value))} in merchandise value, the strongest month in the series.`;
    const states = renderStates(data.states), stateShare = number(states[0].merchandise_value) / data.states.reduce((sum, row) => sum + number(row.merchandise_value), 0); document.querySelector('#state-copy').textContent = `${states[0].state} contributes ${money(number(states[0].merchandise_value))}, or ${(stateShare * 100).toFixed(1)}% of merchandise value.`;
    renderCategories(data.categories); renderDelivery(data.delivery);
    let sortByUnits = true; document.querySelector('#category-sort').addEventListener('click', () => { sortByUnits = !sortByUnits; document.querySelector('#category-sort').innerHTML = `Sort by ${sortByUnits ? 'units' : 'value'} <span>↕</span>`; renderCategories(data.categories, sortByUnits); });
    window.addEventListener('resize', () => drawTrend(trendRows));
  } catch (error) { document.querySelector('main').innerHTML = `<section class="intro"><div><p class="eyebrow">Dashboard unavailable</p><h1>Data could not be loaded.</h1><p class="lede">Open this page through a local web server so the dashboard can read the processed CSV files.</p></div></section>`; console.error(error); }
}
init();
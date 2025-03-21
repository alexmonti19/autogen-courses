# filename: ytd_stock_gains.py
import yfinance as yf
import matplotlib.pyplot as plt
from datetime import datetime

# Define the tickers
tickers = ['NVDA', 'TLSA']

# Get today's date and the start of the year
today = datetime(2025, 3, 20)
start_of_year = datetime(2025, 1, 1)

# Fetch the stock data
data = yf.download(tickers, start=start_of_year, end=today)

# Calculate YTD gains
ytd_gains = {}
for ticker in tickers:
    price_start = data['Close'][ticker].iloc[0]  # price at the beginning of the year
    price_current = data['Close'][ticker].iloc[-1]  # current price
    gain = ((price_current - price_start) / price_start) * 100  # YTD gain percentage
    ytd_gains[ticker] = gain

# Create a bar plot
plt.bar(ytd_gains.keys(), ytd_gains.values(), color=['blue', 'orange'])
plt.title('YTD Stock Gains (NVDA vs TLSA)')
plt.xlabel('Stock Ticker')
plt.ylabel('YTD Gain (%)')
plt.ylim(min(ytd_gains.values()) - 5, max(ytd_gains.values()) + 5)

# Save the figure
plt.savefig('ytd_stock_gains.png')

# Show the plot (optional, you may want to skip this in a script)
plt.show()
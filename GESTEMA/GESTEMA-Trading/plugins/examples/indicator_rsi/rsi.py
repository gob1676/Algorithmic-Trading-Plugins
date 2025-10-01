def compute_rsi(prices, period=14):
    # Placeholder implementation. Real logic will arrive with the indicators module phase.
    if not prices or len(prices) < period + 1:
        return []
    return [50.0] * len(prices)

if __name__ == "__main__":
    print("RSI plugin skeleton loaded")

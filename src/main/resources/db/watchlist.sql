-- Create watchlist table
CREATE TABLE IF NOT EXISTS public.watchlist (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    show_id VARCHAR(20) NOT NULL,  -- IMDb ID format
    title VARCHAR(255) NOT NULL,
    poster TEXT,
    year VARCHAR(10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(user_id, show_id)  -- Prevent duplicate shows in watchlist
);

-- Enable Row Level Security
ALTER TABLE public.watchlist ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own watchlist"
    ON public.watchlist
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can add to their own watchlist"
    ON public.watchlist
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own watchlist items"
    ON public.watchlist
    FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can remove from their own watchlist"
    ON public.watchlist
    FOR DELETE
    USING (auth.uid() = user_id);

-- Create an index for faster lookups
CREATE INDEX IF NOT EXISTS idx_watchlist_user_id ON public.watchlist(user_id);

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc', NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create a trigger to automatically update the updated_at column
CREATE TRIGGER update_watchlist_updated_at
    BEFORE UPDATE ON public.watchlist
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 
import '../styles/globals.css'
import type { AppProps } from 'next/app'

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <div>
      <nav className="border-b p-6">
        <p className="text-4xl font-bold underline">NFT Marketplace</p>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}

export default MyApp

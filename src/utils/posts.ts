import type { CollectionEntry } from "astro:content";

type BlogPost = CollectionEntry<"blog">;

const now = new Date();

export function isPublishedPost(post: BlogPost): boolean {
  return !post.data.draft && post.data.pubDate <= now;
}

export function sortPostsNewestFirst(posts: BlogPost[]): BlogPost[] {
  return posts.sort((a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf());
}